class ItemController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :allow_cross_domain_ajax

  def list_items
    item = Item.all
    if item.nil?
      render status: 404, json: {Status: "No Items Present"}.to_json
    else
      item_array = []
      item.each { |t|
        item_hash = {:id=>t[:id],:name=>t[:name]}
        item_array.push(item_hash)
      }
      render status: 200, json: {Status: item_array}.to_json
    end
  end

  def list_bills
    bill = Bill.all
    if bill.nil?
      render status: 404, json: {Status: "No Bills Present"}.to_json
    else
      render status: 200, json: {Status: bill}.to_json
    end
  end

  def create
    @item = Item.new(name:params[:name],price:params[:price])
    if @item.save
      params[:hashtag].each { |t|
        hashtag = HashTag.find_by(name: t)
        if hashtag
          hasttagrelation = ItemTagRelationship.create(item_id: Item.last.id,tag_id: hashtag.id)
        else
          hashtag = HashTag.create(name: t)
          hasttagrelation = ItemTagRelationship.create(item_id: Item.last.id,tag_id: HashTag.last.id)
        end
      }
      render status: 200, json: {Status: "Item created Successfully"}.to_json
    else
      render status: 500, json: {Status: "Bad Request or Item with Same Already Present"}.to_json
    end
  end

  def search
    result = Item.find_by_sql(["SELECT * FROM items WHERE id = (SELECT items.id FROM items LEFT JOIN item_tag_relationships ON item_tag_relationships.item_id = items.id JOIN hash_tags ON hash_tags.id = item_tag_relationships.tag_id WHERE hash_tags.name = ?)", ActionController::Base.helpers.sanitize(params[:key])])
    if result.any?
      render status: 200, json: {Status: result}.to_json
    else
      render status: 404, json: {Status: "Result not found"}.to_json
    end
  end


  def generate_bill
    bill_amt = 0
    items_array = []
    params[:items].each { |key,value|
      item = Item.find_by(id: value[:item_id])
      bill_amt += item[:price]*value[:qty].to_f
      item_hash = {:item_id=> value[:item_id],:unit_price=> item[:price], :qty=> value[:qty]}
      items_array.push(item_hash)
    }
    svc_charge = bill_amt * 0.15
    total = svc_charge + bill_amt
    bill = Bill.create(bill_amount: bill_amt,service_charge: svc_charge,grand_total: total)
    if bill
      items_array.each { |i|
        bill_item = BillItem.create(bill_id: Bill.last.id,item_id: i[:item_id],item_qty: i[:qty],unit_price: i[:unit_price])
    }
       render status: 200,json: {Message: "Bill Generated Sucessfully"}.to_json
    else
      render status: 500,json: {Message: "Something somewhere went terribly wrong1"}.to_json
    end

  end

  def show_bill
    bill = Bill.find_by(id: params[:order_id])
    if bill.nil?
      render status: 404,json: {Message: "No bills found"}
    else
      bill_item = BillItem.where(bill_id: params[:order_id])
      item = []
      bill_item.each { |t|
        item_name = Item.find_by(id: t[:item_id])
        item_hash = {:item_name => item_name[:name],:unit_price => t[:unit_price],:qty => t[:item_qty]}
        item.push(item_hash)
      }
      result = {:bill_amount => bill[:bill_amount], :service_charge => bill[:service_charge], :grand_total=> bill[:grand_total],:create_at=>bill[:created_at],:items=> item}
      render status: 200,json: {bill: result}
    end
  end

  private

     def allow_cross_domain_ajax
        headers['Access-Control-Allow-Origin'] = '*' #ideally this should be domain specific but we have kept it * for now
        headers['Access-Control-Request-Method'] = 'GET ,POST'
  end
end

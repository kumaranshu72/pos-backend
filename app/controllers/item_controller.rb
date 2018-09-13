class ItemController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @item = Item.new(item_params)
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
      render status: 500, json: {Status: "Bad Request"}.to_json
    end
  end

  private
     def item_params
       params.require(:item).permit(:name, :price, :hashtag)
     end
end

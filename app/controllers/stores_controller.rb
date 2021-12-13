class StoresController < ApplicationController
  before_action :set_store, only: %i[ show edit update destroy ]

  # GET /stores or /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1 or /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: "Store was successfully updated." }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: "Store was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def incitem
    @found = false
    Bucketlib.where("user_id": session[:user_id]).ids.each do |bucketlibid|
      if Bucketitem.find_by("item_id":params[:item_id],"bucketlib_id":bucketlibid) != nil
        @newquan = Bucketlib.find_by("id":bucketlibid).quantity + 1
        Bucketlib.find_by("id":bucketlibid).update("user_id": session[:user_id],"quantity":@newquan)
        @found = true
      end
    end
    if @found == false
      tmp = Bucketlib.create("user_id":session[:user_id],"quantity":1)
      Bucketitem.create("item_id":params[:item_id],"bucketlib_id":tmp.id)
    end
    @sid = Item.find_by("id":params[:item_id]).store_id
    @sname = Store.find(@sid).name
    redirect_to request.referrer

  end
  
  def decitem
    Bucketlib.where("user_id": session[:user_id]).ids.each do |bucketlibid|
      if Bucketitem.find_by("item_id":params[:item_id],"bucketlib_id":bucketlibid) != nil
        @newquan = Bucketlib.find_by("id":bucketlibid).quantity - 1
        if @newquan > 0
          Bucketlib.find_by("id":bucketlibid).update("user_id": session[:user_id],"quantity":@newquan)
        elsif @newquan == 0
          tmp = Bucketlib.find_by("id":bucketlibid)
          Bucketitem.find_by("bucketlib_id":bucketlibid).destroy
          tmp.destroy
        end
      end 
    end
    @sid = Item.find_by("id":params[:item_id]).store_id
    @sname = Store.find(@sid).name
    redirect_to request.referrer

  end
  
  def confirmpur
    @user = User.find_by(params[:user_id])
    @inbucket = []
  	@totalprice = 0
  	@bucketlibs = Bucketlib.where("user_id":session[:user_id])
  	@bucketlibs.each do |bucketlib|
  	  @bid = bucketlib.id
  	  @item_id = Bucketitem.find_by("bucketlib_id":@bid).item_id
  	  @item_quantity = bucketlib.quantity
  	  @inbucket.push([@item_id,@item_quantity])
  	  @totalprice += Item.find_by("id":@item_id).price * @item_quantity
       end
  end
  
  def recordpur
    @newOrder = Order.create("purdate":Date.today,"user_id":session[:user_id])
    @orderID = @newOrder.id
    
    @store = Store.find_by(name: params[:name])
    @inbucket = []
    @totalprice = 0
    @bucketlibs = Bucketlib.where("user_id":session[:user_id])
    @bucketlibs.each do |bucketlib|
      @bid = bucketlib.id
      @item_id = Bucketitem.find_by("bucketlib_id":@bid).item_id
      @item_quantity = bucketlib.quantity
      @item_price = Item.find_by("id":@item_id).price
      Orderline.create("item_id":@item_id,"soldprice":@item_price,"quantity":@item_quantity,"order_id":@orderID)
    end
    
    Bucketlib.where("user_id": session[:user_id]).ids.each do |bucketlibid|
      Bucketitem.find_by("bucketlib_id":bucketlibid).destroy
      Bucketlib.find_by("user_id": session[:user_id]).destroy
    end
    redirect_to track_page_path
  end
  
  def storepage
        @rating = Rating.new()
  	@store = Store.find_by(name: params[:name])
  	session[:view] = "seller"
  	@allItem = []
  	@store.items.each do |item|
  	  item.taglibs.each do |tag|
            tmp = [tag.tag_name,item.name,item.price,item.pic,item.id]
            @allItem.push(tmp)
  	  end
  	end
  	@allItem = @allItem.sort_by{ |tag| tag }
  	@prevtag = nil
  	
  	if(session[:user_type] == "buyer")
  	  @inbucket = []
  	  @totalprice = 0
  	  @bucketlibs = Bucketlib.where("user_id":session[:user_id])
  	  @bucketlibs.each do |bucketlib|
  	    @bid = bucketlib.id
  	    @item_id = Bucketitem.find_by("bucketlib_id":@bid).item_id
  	    @item_quantity = bucketlib.quantity
  	   @inbucket.push([@item_id,@item_quantity])
  	    @totalprice += Item.find_by("id":@item_id).price * @item_quantity
          end
       
         @favlibid = User.find(session[:user_id]).favlib.id
         @favitem = Favitem.where("favlib_id":@favlibid).pluck("item_id")
       end
       @allcomment = Rating.where("store_id": @store.id)
  end
  
  def favitem
    if Favlib.find_by("user_id":session[:user_id]) == nil
      tmp = Favlib.create("user_id":session[:user_id])
      Favitem.create("item_id":params[:item_id],"favlib_id":tmp.id)
    elsif
      tmp = Favlib.find_by("user_id":session[:user_id])
      Favitem.create("item_id":params[:item_id],"favlib_id":tmp.id)
    end
    
    @store = Store.find_by(name: params[:name])
    redirect_to store_page_path(@store.name)
    
  end
  
  def unfavitem
    tmp = Favlib.find_by("user_id":session[:user_id])
    Favitem.find_by("item_id":params[:item_id],"favlib_id":tmp.id).destroy
    @store = Store.find_by(name: params[:name])
    redirect_to store_page_path(@store.name)
  end
  
  def addcomment
    @sid = params[:rating][:store_id]
    @uid = params[:rating][:user_id]
    @score = params[:rating][:ratescore]
    @comment = params[:rating][:comment]
    Rating.create("comdate": Date.current,"ratescore":@score,"comment":@comment,"store_id":@sid,"user_id":@uid)
    redirect_to request.referrer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.require(:store).permit(:name, :password, :address, :joindate, :rating, :avatar, :cover)
    end
end

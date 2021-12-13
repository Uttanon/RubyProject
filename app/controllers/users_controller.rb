class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def login
    @user = User.new
    session[:user_id] = nil
    session[:user_type] = nil
  end
  def recieve_login_info
    @commit = params[:commit]
    @loginUsername = params[:user][:username]
    @loginPassword = params[:user][:password]
      if(@commit == 'Login')
        @usermatch = false
        @find = User.find_by(username:@loginUsername)
        @finds = Store.find_by(name:@loginUsername)
        if(@find && @find.authenticate(@loginPassword))
          redirect_to user_page_path(@loginUsername), notice: "Login successfully."
          @usermatch = true
          session[:user_id] = @find.id
          session[:user_type] = "buyer"
          session[:view] = "buyer"
        elsif(@finds && @finds.authenticate(@loginPassword))
          redirect_to store_page_path(@loginUsername), notice: "Login successfully."
          @usermatch = true
          session[:user_id] = @finds.id
          session[:user_type] = "seller"      
          session[:view] = "seller"
        end
        if(@usermatch == false)
          redirect_to login_path, alert: "Email/Password incorrect."
        end
      elsif(@commit == 'Register')
        redirect_to choose_type_path
      end
  end
  def choosetype
  end
  def userpage
    @user = User.find_by(username: params[:username])
    session[:view] = "buyer"
    
    @allfav = []
    if Favlib.find_by("user_id":@user.id) == nil
      Favlib.create("user_id":@user.id)
    end
    @favitems = Favlib.find_by("user_id":@user.id).favitems
    @favitems.each do |favitem|
      favitem.item.taglibs.each do |tag|
        @tmp = [tag.tag_name,favitem.item.name,favitem.item.price,favitem.item.pic,favitem.item.id]
        @allfav.push(@tmp)
      end
    end
    @allfav = @allfav.sort_by{ |tag| tag }
    @favlibid = User.find(session[:user_id]).favlib.id
    @favitem = Favitem.where("favlib_id":@favlibid).pluck("item_id")
    
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
  def track
    @allrecord = []
    @user = User.find(session[:user_id])
    @allOrder = Order.where("user_id":@user.id)
    @allOrder.each do |order|
      @orderID = order.id
      @allOrderline = Orderline.where("order_id":@orderID)
      @allOrderline.each do |orderline|
        @tmp = [@orderID,orderline.item_id,orderline.quantity,orderline.soldprice]
        @allrecord.push(@tmp)
      end
    end
    @prevID = nil
  end
  
  def vieworder
    @allrecord = []
    @orderID = params[:order_id]
    @allOrderline = Orderline.where("order_id":@orderID)
    @allOrderline.each do |orderline|
      @tmp = [orderline.item_id,orderline.quantity,orderline.soldprice]
      @allrecord.push(@tmp)
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :email, :name, :address, :phone, :gender, :birthdate, :avatar)
    end
end

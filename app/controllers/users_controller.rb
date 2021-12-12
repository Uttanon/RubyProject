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

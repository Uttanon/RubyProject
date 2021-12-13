require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "login-sucess" do
    @user = users(:user1)
    visit login_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: "1234"
    find("#loginbutton").click
    assert_text "Login successfully."
  end

  test "login-fail" do
    @user = users(:user1)
    visit login_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: "123"
    find("#loginbutton").click
    assert_text "Email/Password incorrect."
  end
  
  test "register-buyer-success" do
    visit login_path
    find("#registerbutton").click
    click_on("Create New User")
    fill_in "Username", with: "a"
    fill_in "Password", with: "1234"
    click_on("Create User")
    assert_text "User was successfully created."
  end
  
  test "register-buyer-fail" do
    visit login_path
    find("#registerbutton").click
    click_on("Create New User")
    fill_in "Username", with: "a"
    click_on("Create User")
    assert_text "Please review the problems below:"
  end

  test "register-seller-success" do
    visit login_path
    find("#registerbutton").click
    click_on("Create New Store")
    fill_in "Name", with: "a"
    fill_in "Password", with: "1234"
    click_on("Create Store")
    assert_text "Store was successfully created."
  end
  
  test "register-seller-fail" do
    visit login_path
    find("#registerbutton").click
    click_on("Create New Store")
    fill_in "Name", with: "a"
    click_on("Create Store")
    assert_text "Please review the problems below:"
  end
  test "favorite" do
    @user = users(:user1)
    visit login_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: "1234"
    find("#loginbutton").click
    visit store_page_path("jj")
    click_on("Favorite")
    visit user_page_path("a")
    assert_text "stonemask"
  end
  test "additem" do
    @user = users(:user1)
    visit login_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: "1234"
    find("#loginbutton").click
    visit store_page_path("jj")
    click_on("+")
    assert_text "stonemask x 1"
  end  
  test "remitem" do
    @user = users(:user1)
    visit login_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: "1234"
    find("#loginbutton").click
    visit store_page_path("jj")
    click_on("+")
    assert_text "stonemask x 1"
    click_on("-")
    assert_text "Total: 0"
  end
  test "buyitem" do
  @user = users(:user1)
    visit login_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: "1234"
    find("#loginbutton").click
    visit store_page_path("jj")
    click_on("+")
    click_on("Confirm")
    click_on("Confirm")
    assert_text "Name:stonemask Quantity:1 SoldPrice:50"
  end
  test "vieworder" do
    @user = users(:user1)
    visit login_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: "1234"
    find("#loginbutton").click
    visit store_page_path("jj")
    click_on("+")
    click_on("Confirm")
    click_on("Confirm")
    click_on("View Order")
    assert_text "stonemask x 1"
    assert_text "B 50"
  end
  test "comment" do
    @user = users(:user1)
    visit login_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: "1234"
    find("#loginbutton").click
    visit store_page_path("jj")
    fill_in "Ratescore", with: "5"
    fill_in "Comment", with: "JOOOOJO"
    click_on("Create Rating")
    assert_text "JOOOOJO"
  end
end

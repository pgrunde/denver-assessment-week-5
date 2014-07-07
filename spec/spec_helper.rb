require "database"
require "contact_database"
require "capybara/rspec"
require "./app"

Capybara.app = ContactsApp

feature "homepage" do
  scenario "logged out user can see homepage" do
    visit "/"
    expect(page).to have_content("Contacts")
  end
  scenario "logged out user can get to the log in form" do
    visit "/"
    click_link "Login"
    expect(page).to have_content("Username:")
  end
  scenario "user can log in" do
    visit "/login/"

    fill_in("username", :with => "Jeff")
    fill_in("password", :with => "jeff123")

    click_button "Login"

    expect(page).to have_content("Welcome, Jeff")
  end
  scenario "user can see their contacts" do
    visit "/login/"

    fill_in("username", :with => "Jeff")
    fill_in("password", :with => "jeff123")

    click_button "Login"

    expect(page).to have_content("spen@example.com")
  end
  scenario "user can log out" do
    visit "/login/"

    fill_in("username", :with => "Jeff")
    fill_in("password", :with => "jeff123")

    click_button "Login"
    click_link "Logout"

    expect(page).to have_content("Contacts")
  end
end
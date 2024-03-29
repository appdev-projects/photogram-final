require "rails_helper"


describe "The home page" do
  it "can be visited when user is signed out", points: 0 do
    visit "/"
    current_url = page.current_path

    expect(current_url).to eq("/")
  end
end

describe "The home page" do
  it "has a link to /users", points: 1 do
    visit "/"

    expect(page).to have_tag("a", :with => {:href => "/users" }, :text => /All users/i),
      "Expected to find link with text 'All users' to '/users', but didn't find it."
  end
end

describe "The home page" do
  it "has a link to /photos", points: 1 do
    visit "/"
    
    expect(page).to have_tag("a", :with => {:href => "/photos" }, :text => /All public photos/i),
      "Expected to find link with text 'All public photos' to '/photos', but didn't find it."
  end
end

describe "The home page" do
  it "has a link to /users/sign_in when no user is signed in", points: 1 do
    visit "/"
    
    expect(page).to have_tag("a", :with => {:href => "/users/sign_in" }, :text => /Sign in/i),
      "Expected to find link with text 'Sign in' to '/users/sign_in', but didn't find it."
  end
end

describe "The home page" do
  it "has a link to /users/sign_up when no user is signed in", points: 1 do
    visit "/"
    
    expect(page).to have_tag("a", :with => {:href => "/users/sign_up" }, :text => /Sign up/i),
      "Expected to find link with text 'Sign up' to '/users/sign_up', but didn't find it."
  end
end

describe "The home page" do
  it "has a link to /users/sign_out when user is signed in", points: 1 do
    
    anna_belle = User.new
    anna_belle.password = "password"
    anna_belle.username = "anna_belle"
    anna_belle.private = false
    anna_belle.email = "anna_belle@example.com"
    anna_belle.save

    visit "/users/sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: anna_belle.email
      fill_in "Password", with: anna_belle.password
      
      find('input[type="submit"]').click
    end

    expect(page).to have_tag("a", :with => {:href => "/users/sign_out" }, :text => /Sign out/i),
      "Expected to find link with text 'Sign out' to '/users/sign_out', but didn't find it."
  end
end

describe "/users/edit" do
  it "can update the signed in user", points: 1 do
    anna_belle = User.new
    anna_belle.password = "password"
    anna_belle.username = "anna_belle"
    anna_belle.private = false
    anna_belle.email = "anna_belle@example.com"
    anna_belle.save

    visit "/users/sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: anna_belle.email
      fill_in "Password", with: anna_belle.password
      
      find('input[type="submit"]').click
    end
    
    new_username = "canna_belle"

    visit "/users/edit"
    
    within(:css, "form#edit_user") do
      fill_in "Username", with: new_username
      fill_in "Current password", with: anna_belle.password
      
      find('input[type="submit"][value="Update"]').click
    end

    visit "/"

    expect(page).to have_text(new_username),
      "Expected to find #{new_username} on the page but didn't find it."
  end
end

describe "The home page" do
  it "has a notice when you sign in successfully", points: 1 do

    anna_molly = User.new
    anna_molly.password = "password"
    anna_molly.username = "anna_molly"
    anna_molly.private = false
    anna_molly.email = "anna_molly@example.com"
    anna_molly.save

    visit "/users/sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: anna_molly.email
      fill_in "Password", with: anna_molly.password
      
      find('input[type="submit"]').click
    end

    expect(page).to have_text(/Signed in successfully/i),
      "Expected to find 'Signed in successfully' on the page after the Sign in link is clicked, but didn't find it."
  end
end

describe "The home page" do
  it "has a notice when you signed out successfully", points: 1 do

    anna_molly = User.new
    anna_molly.password = "password"
    anna_molly.username = "anna_molly"
    anna_molly.private = false
    anna_molly.email = "anna_molly@example.com"
    anna_molly.save

    visit "/users/sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: anna_molly.email
      fill_in "Password", with: anna_molly.password
      
      find('input[type="submit"]').click
    end

    visit "/"

    find("a", :text => /Sign out/i).click

    expect(page).to have_text(/Signed out successfully/i),
      "Expected to find 'Signed out successfully' after clicking 'Sign out' but didn't find it."
    end
  end

describe "The home page" do
  it "has a notice when you add a Photo successfully", points: 1, hint: h("real_image_uploads") do
    visit "/"
    
    anna_belle = User.new
    anna_belle.password = "password"
    anna_belle.username = "anna_belle"
    anna_belle.private = false
    anna_belle.email = "anna_belle@example.com"
    anna_belle.save
    
    visit "/users/sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: anna_belle.email
      fill_in "Password", with: anna_belle.password
      
      find('input[type="submit"]').click
    end
    
    visit "/photos"
    
    within(:css, "form") do
      attach_file "Image", "#{Rails.root}/spec/support/kirb.gif"
      fill_in "Caption", with: "The Magnus Institute"
      
      find("button", :text => /Add photo/i).click
    end
    
    expect(page).to have_text(/Photo created successfully/i),
      "Expected to find 'Photo created successfully' on the page after the form submits, but didn't find one."
      
  end
end

describe "The home page" do
  it "has a notice when you Like a Photo successfully", points: 1 do
 
    anna_belle = User.new
    anna_belle.password = "password"
    anna_belle.username = "anna_belle"
    anna_belle.private = false
    anna_belle.email = "anna_belle@example.com"
    anna_belle.save
    
    photo = Photo.new
    photo.owner_id = anna_belle.id
    photo.image = File.open(Rails.root + "spec/support/kirb.gif")
    photo.likes_count = 0
    photo.comments_count = 0
    photo.caption = "anna's caption"
    photo.save

    visit "/users/sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: anna_belle.email
      fill_in "Password", with: anna_belle.password
      
      find('input[type="submit"]').click
    end
    
    visit "/photos/#{photo.id}"
    
    find("button", :text => /Like/i).click
    
    expect(page).to have_text(/Like created successfully/i),
      "Expected to find 'Like created successfully' on the page after the form submits, but didn't find one."
  end
end

describe "The home page" do
  it "has an alert when you Unlike a Photo", points: 1 do
 
    anna_belle = User.new
    anna_belle.password = "password"
    anna_belle.username = "anna_belle"
    anna_belle.private = false
    anna_belle.email = "anna_belle@example.com"
    anna_belle.save
    
    photo = Photo.new
    photo.owner_id = anna_belle.id
    photo.image = File.open(Rails.root + "spec/support/kirb.gif")
    photo.caption = "anna's caption"
    photo.likes_count = 0
    photo.comments_count = 0
    photo.save
    
    like = Like.new
    like.fan_id = anna_belle.id
    like.photo_id = photo.id
    like.save
    
    photo.likes_count = 1
    photo.save
    
    visit "/users/sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: anna_belle.email
      fill_in "Password", with: anna_belle.password
      
      find('input[type="submit"]').click
    end
    
    visit "/photos/#{photo.id}"
    
    find("a", :text => /Unlike/i).click
    
    expect(page).to have_text(/Like deleted successfully/i),
      "Expected to find 'Like deleted successfully' on the page after the link is clicked, but didn't find it."
  end
end

describe "The home page" do
  it "has an alert when you try to visit a page you're not allowed to.", points: 1 do

    anna_belle = User.new
    anna_belle.password = "password"
    anna_belle.username = "anna_belle"
    anna_belle.private = false
    anna_belle.email = "anna_belle@example.com"
    anna_belle.save
    
    photo = Photo.new
    photo.owner_id = anna_belle.id
    photo.image = File.open(Rails.root + "spec/support/kirb.gif")
    photo.caption = "anna's caption"
    photo.save

    visit "/"

    visit "/photos/#{photo.id}"

    expect(page).to have_text(/You need to sign in or sign up before continuing/i),
      "Expected to find 'You need to sign in or sign up before continuing.' on the page if you visit the photo details page without signing in, but didn't find it."
  end
end

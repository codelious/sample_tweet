require 'spec_helper'

describe "Paginas estaticas" do
  
  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: (page_title)) }
  end
    
  
  describe "Pagina Home" do
    before { visit root_path } 
    let(:heading) { 'Sample App' }
    let(:page_title) { 'Home' }
    
    it_should_behave_like "all static pages"    
    
    describe "para usuarios logeados" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in(user)
        visit root_path
      end
      
      it "debe renderizar el feed de usuario" do
        user.feed.each do |item|
          page.should have_selector("tr##{item.id}", text: item.content)
        end
      end
    end
  end
  
  describe "pagina Help" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end
  
  describe "pagina About" do
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end
  
  describe "pagina Contact" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end
  
  it "debe tener los links correctos" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: 'About Us'
    click_link "Help"
    page.should have_selector 'title', text: 'Help'
    click_link "Contact"
    page.should have_selector 'title', text: 'Contact'
    click_link "Home"
    page.should have_selector 'title', text: 'Sample App'
    click_link "Sign up now!"
    page.should have_selector 'title', text: 'Sign up'
  end
  
end

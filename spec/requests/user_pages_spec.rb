require 'spec_helper'

describe "UserPages" do
  
  subject { page }
  
  describe "pagina de perfil" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
  
  describe "pagina de signup" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: 'Sign up') }
  end
  
  describe "signup" do
    
    before { visit signup_path }
    
    describe "con informacion invalida" do
      it "no debe crear un usuario" do
        expect { click_button "Sign up" }.not_to change(User, :count)
      end
    end
    
    describe "con informacion valida" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Password confirmation", with: "foobar"
      end
      
      it "debe crear un usuario" do
        expect { click_button "Sign up" }.to change(User, :count).by(1)
      end
      
      describe "despues de guardar usuario" do
        before { click_button "Sign up" }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.flash.success', text: 'Bienvenido') }
      end
    end
    
    describe "mensajes de error" do
      before { click_button "Sign up" }
      
      let(:error) { 'errors prohiben que este usuario se guarde'}
      
      it { should have_selector('title', text: 'Sign up') }
      it { should have_content(error) }
    end
  end
  
end

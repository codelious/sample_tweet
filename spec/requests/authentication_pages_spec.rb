require 'spec_helper'

describe "Authentication" do
  
  subject { page }
  
  describe "pagina signin" do
    before { visit signin_path }
    
    it { should have_selector('h1', text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end
  
  describe "signin" do
    before { visit signin_path }
    
    describe "con informacion invalida" do
      before { click_button "Sign in" }
      
      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.flash.error', text: 'Invalid')}
      
      describe "despues de visitar otra pagina" do
        before { click_link "Home" }
        it { should_not have_selector('div.flash.error')}
      end
    end
    
    describe "con informacion valida" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      it { should have_selector('title', text: user.name )}
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }  # Este link por defecto traia un method: :delete que no logra funcionar
        it { should have_link('Sign in') }
      end
    end
  end
  
  describe "autorizacion" do
    
    describe "para usuarios no autenticados" do
      let(:user) { Factory(:user) }
      
      describe "en el controlador de usuarios" do
        
        describe "visitando la pagina de edicion" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in')}
        end
        
        describe "enviando la accion update" do
          before  { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end
  end

end

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
      #before { valid_signin(user) }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      it { should have_selector('title', text: user.name ) }
      
      it { should have_link('Users', href: users_path) }
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
      
      describe "vistando index de usuarios" do
        before { visit users_path }
        it { should have_selector('title', text: 'Sign in')}
      end
    end
    
    describe "como usuario incorrecto" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }
      
      describe "visitando Users#edit" do
        before { visit edit_user_path(wrong_user) }
        it { should have_selector('title', text: 'Home') }
      end
      
      describe "enviando un PUT request a User#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    describe "para usuario no autenticado" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "cuando se intenta visitar una pagina protegida" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
      end
      
      #describe "despues de signing in" do
      #  
      #  it "debe renderizar la pagina deseada protegida" do
      #    page.should have_selector('title', text: 'Edit user')
      #  end
      #end
    end
    
  end

end

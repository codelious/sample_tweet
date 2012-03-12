require 'spec_helper'

describe "UserPages" do
  
  subject { page }
  
  describe "index" do
    
    let(:user) { FactoryGirl.create(:user) }
    
    before do
      #sign_in FactoryGirl.create(:user)
      #FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      #FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      sign_in user
      visit users_path
    end
    
    it { should have_selector('title', text: 'All users') }
    
    describe "paginacion" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      
      it { should have_link('Next') }
      it { should have_link('2') }
      
      it "should list each user" do
        User.all[0..2].each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
      
      it { should_not have_link('delete') }
      
      describe "como un usuario administrador" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete').to change(User, :count).by(-1) }
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
      
    end
    
    #it "debe listar cada usuario" do
    #  User.all.each do |user|
    #    page.should have_selector('li', text: user.name)
    #  end
    #end
  end
  
  
  describe "pagina de perfil" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "bar") }
    
    before { visit user_path(user) }
    
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
    
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
    
    describe "botones follow/unfollow" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in(user) }
      
      describe "siguiendo un usuario" do
        before { visit user_path(other_user) }
        
        it "debe incrementar el conteo de usuario seguido" do
          expect do
            click_button "Follow"            
          end.to change(user.followed_users, :count).by(1)
        end
        
        it "debe incrementar el conteo de seguidores de otro usuario" do
          expect do
            click_button "Follow"            
          end.to change(other_user.followers, :count).by(1)
        end
        
        describe "activando el boton" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end
      
      describe "dejar de seguir un usuario" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end
        
        it "debe decrementar conteo de usuario seguido" do
          expect do
            click_button "Unfollow"            
          end.to change(user.followed_users, :count).by(-1)
        end
        
        it "debe decrementar conteo de seguidores de otro usuario" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end
        
        describe "activando el boton" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end
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
        it { should have_link('Sign out') }
      end
    end
    
    describe "mensajes de error" do
      before { click_button "Sign up" }
      
      let(:error) { 'errors prohiben que este user se guarde'}
      
      it { should have_selector('title', text: 'Sign up') }
      it { should have_content(error) }
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1', text: "Edit user") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end
    
    describe "con informacion invalida" do
      let(:error) { '1 error prohiben que este user se guarde' }
      before { click_button "Update" }
      
      it { should have_content(error) }
    end
    
    describe "con informacion valida" do
      let(:user) { FactoryGirl.create(:user) }
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Update"
      end
      
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.flash.success') }
      it { should have_link('Sign out', :href => signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
  
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }
    
    describe "followed users" do
      before do
        sign_in(user)
        visit following_user_path(user)
      end
      
      it { should have_selector('a', href: user_path(other_user),
                                      text: other_user.name) }
    end
    
    describe "followers" do
      before do
        sign_in(other_user)
        visit followers_user_path(other_user)
      end
      
      it { should have_selector('a', href: user_path(user),
                                     text: user.name) }
    end
  end
end

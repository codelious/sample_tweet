require 'spec_helper'

describe "paginas de Micropost" do
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in(user) }
  
  describe "creacion de micropost" do
    before { visit root_path }
    
    describe "con informacion invalida" do
      
      it "no debe crear un micropost" do
        expect { click_button "Submit" }.should_not change(Micropost, :count)
      end
      
      describe "mensajes de error" do
        let(:error) { '1 error prohiben que este micropost se guarde' }
        before { click_button "Submit" }
        it { should have_content(error) }
      end
    end
    
    describe "con informacion valida" do
      
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "debe crear un micropost" do
        expect { click_button "Submit"}.should change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "destruccion de micropost" do
    before { FactoryGirl.create(:micropost, user: user)}
    
    describe "como usuario correcto" do
      before { visit root_path }
      
      it "debe borrar un micropost" do
        expect { click_link "delete" }.should change(Micropost, :count).by(-1)
      end
    end
  end
end

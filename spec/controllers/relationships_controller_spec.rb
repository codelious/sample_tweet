require 'spec_helper'

describe RelationshipsController do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  
  before { sign_in(user) }
  
  describe "creanto una relacion con Ajax" do
    it "decrementa el conteo de relacion" do
      expect do
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.should change(Relationship, :count).by(1)
    end
  end
  
  describe "destruyendo una relacion con Ajax" do
    
    before { user.follow!(other_user) }
    let(:relationship) { user.relationships.find_by_followed_id(other_user) }
    
    it "should destroy a relationship using Ajax" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.should change(Relationship, :count).by(-1)
    end
  end
end

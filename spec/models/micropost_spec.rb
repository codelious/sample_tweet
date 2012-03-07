require 'spec_helper'

describe Micropost do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
    
  subject { @micropost }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  
  it { should be_valid }
  
  describe "cuando user_id no esta presente" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "cuando contenido es blanco" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end
  
  describe "con contenido que es muy largo" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end
# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#


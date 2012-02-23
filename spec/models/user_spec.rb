# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  
  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar") }
  
  subject { @user }
  
  it { should respond_to(:name ) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  
  it { should be_valid }
  
  describe "cuando el nombre no esta presente" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  describe "cuando el email no esta presente" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "cuando el nombre es muy largo" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "cuando el formato de email es invalido" do
    invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_addresses.each do |invalid_address|
      before { @user.email = invalid_address }
      it { should_not be_valid }
    end
  end
  
  describe "cuando el formato de email es valido" do
    valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    valid_addresses.each do |valid_address|
      before { @user.email = valid_address }
      it { should be_valid }
    end  
  end
  
  describe "cuando el email ya existe" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end

  describe "cuando el password no esta presente" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "cuando el password no coincide" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }  
  end
  
  describe "con un password que es muy corto" do
    before { @user.password = @user.password_confirmation = "a" * 5}
    it { should be_invalid }
  end
  
  describe "retorna valor de metodo authenticate" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    
      describe "con password valido" do
        it { should == found_user.authenticate(@user.password) }
      end
      
      describe "con password invalido" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid")}
        
        it { should_not == user_for_invalid_password }
        specify { user_for_invalid_password.should be_false }
      end
  end
  
  describe "recuerda token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
  
end

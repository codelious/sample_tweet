require 'spec_helper'

describe "UserPages" do
  
  subject { page }
  
  describe "pagina de signup" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: 'Sign up') }
  end
  
end

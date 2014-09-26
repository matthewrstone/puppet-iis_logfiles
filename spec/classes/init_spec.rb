require 'spec_helper'
describe 'iis_logfiles' do

  context 'with defaults for all parameters' do
    it { should contain_class('iis_logfiles') }
  end
end

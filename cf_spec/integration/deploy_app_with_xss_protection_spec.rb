require 'spec_helper'

describe 'deploy an app with xss protection' do
  let(:app_name) { 'staticfile_app_with_xss_protection'}
  let(:app)      { Machete.deploy_app(app_name) }
  let(:browser)  { Machete::Browser.new(app) }

  after do
    Machete::CF::DeleteApp.new.execute(app)
  end

  it 'provides the X-XSS-Protection header' do
    expect(app).to be_running

    browser.visit_path('/')
    expect(browser).to have_header('X-XSS-Protection')

    response = Excon.get("http://#{browser.base_url}/")
    expect(response.status).to eq(200)
    expect(response.headers['X-XSS-Protection']).to eq('1; mode=block')
  end
end

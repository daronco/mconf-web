# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

require 'spec_helper'

describe PasswordsController do
  render_views

    describe "#new" do
      before { @request.env["devise.mapping"] = Devise.mappings[:user] }

      describe "if local authentication is enabled in the site" do
        before(:each) { get :new }
        it { should be_true }
      end

      describe "if local authentication is disabled in the site" do
        before { Site.current.update_attribute(:disable_local_auth, true) }
        it { expect { get :new }.to raise_error(ActionController::RoutingError) }
      end
    end

end

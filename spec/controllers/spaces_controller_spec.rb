# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

require "spec_helper"

describe SpacesController do
  render_views

  describe "abilities" do
    render_views(false)

    let(:hash) { { :id => target.to_param } }
    let(:attrs) { FactoryGirl.attributes_for(:space) }
    let(:hash_with_attrs) { hash.merge!(:space => attrs) }

    context "for a superuser", :user => "superuser" do
      let(:user) { FactoryGirl.create(:superuser) }
      before(:each) { login_as(user) }

      it { should allow_access_to(:index) }
      it { should allow_access_to(:new) }
      it { should allow_access_to(:create).via(:post) }

      context "in a public space" do
        let(:target) { FactoryGirl.create(:public_space) }

        context "he is not a member of" do
          it { should allow_access_to(:show, hash) }
          it { should allow_access_to(:edit, hash) }
          it { should allow_access_to(:update, hash_with_attrs).via(:post) }
          it { should allow_access_to(:destroy, hash_with_attrs).via(:delete) }
          it { should allow_access_to(:enable, hash_with_attrs).via(:post) }
          it { should allow_access_to(:leave, hash_with_attrs).via(:post) }
        end

        context "he is a member of" do
          Space::USER_ROLES.each do |role|
            context "with the role '#{role}'" do
              before(:each) { target.add_member!(user, role) }
              it { should allow_access_to(:show, hash) }
              it { should allow_access_to(:edit, hash) }
              it { should allow_access_to(:update, hash_with_attrs).via(:post) }
              it { should allow_access_to(:destroy, hash_with_attrs).via(:delete) }
              it { should allow_access_to(:enable, hash_with_attrs).via(:post) }
              it { should allow_access_to(:leave, hash_with_attrs).via(:post) }
            end
          end
        end
      end

      context "in a private space" do
        let(:target) { FactoryGirl.create(:private_space) }

        context "he is not a member of" do
          it { should allow_access_to(:show, hash) }
          it { should allow_access_to(:edit, hash) }
          it { should allow_access_to(:update, hash_with_attrs).via(:post) }
          it { should allow_access_to(:destroy, hash_with_attrs).via(:delete) }
          it { should allow_access_to(:enable, hash_with_attrs).via(:post) }
          it { should allow_access_to(:leave, hash_with_attrs).via(:post) }
        end

        context "he is a member of" do
          Space::USER_ROLES.each do |role|
            context "with the role '#{role}'" do
              before(:each) { target.add_member!(user, role) }
              it { should allow_access_to(:show, hash) }
              it { should allow_access_to(:edit, hash) }
              it { should allow_access_to(:update, hash_with_attrs).via(:post) }
              it { should allow_access_to(:destroy, hash_with_attrs).via(:delete) }
              it { should allow_access_to(:enable, hash_with_attrs).via(:post) }
              it { should allow_access_to(:leave, hash_with_attrs).via(:post) }
            end
          end
        end
      end

    end

    context "for a normal user", :user => "normal" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) { login_as(user) }

      it { should allow_access_to(:index) }
      it { should allow_access_to(:new) }
      it { should allow_access_to(:create).via(:post) }

      context "in a public space" do
        let(:target) { FactoryGirl.create(:public_space) }

        context "he is not a member of" do
          it { should allow_access_to(:show, hash) }
          it { should_not allow_access_to(:edit, hash) }
          it { should_not allow_access_to(:update, hash_with_attrs).via(:post) }
          it { should_not allow_access_to(:destroy, hash_with_attrs).via(:delete) }
          it { should_not allow_access_to(:enable, hash_with_attrs).via(:post) }
          it { should_not allow_access_to(:leave, hash_with_attrs).via(:post) }
        end

        context "he is a member of" do
          context "with the role 'Admin'" do
            before(:each) { target.add_member!(user, "Admin") }
            it { should allow_access_to(:show, hash) }
            it { should allow_access_to(:edit, hash) }
            it { should allow_access_to(:update, hash_with_attrs).via(:post) }
            it { should allow_access_to(:destroy, hash_with_attrs).via(:delete) }
            it { should_not allow_access_to(:enable, hash_with_attrs).via(:post) }
            it { should allow_access_to(:leave, hash_with_attrs).via(:post) }
          end

          context "with the role 'User'" do
            before(:each) { target.add_member!(user, "User") }
            it { should allow_access_to(:show, hash) }
            it { should_not allow_access_to(:edit, hash) }
            it { should_not allow_access_to(:update, hash_with_attrs).via(:post) }
            it { should_not allow_access_to(:destroy, hash_with_attrs).via(:delete) }
            it { should_not allow_access_to(:enable, hash_with_attrs).via(:post) }
            it { should allow_access_to(:leave, hash_with_attrs).via(:post) }
          end
        end
      end

      context "in a private space" do
        let(:target) { FactoryGirl.create(:private_space) }

        context "he is not a member of" do
          it { should_not allow_access_to(:show, hash) }
          it { should_not allow_access_to(:update, hash_with_attrs).via(:post) }
          it { should_not allow_access_to(:destroy, hash_with_attrs).via(:delete) }
          it { should_not allow_access_to(:enable, hash_with_attrs).via(:post) }
          it { should_not allow_access_to(:leave, hash_with_attrs).via(:post) }
        end

        context "he is a member of" do
          context "with the role 'Admin'" do
            before(:each) { target.add_member!(user, "Admin") }
            it { should allow_access_to(:show, hash) }
            it { should allow_access_to(:edit, hash) }
            it { should allow_access_to(:update, hash_with_attrs).via(:post) }
            it { should allow_access_to(:destroy, hash_with_attrs).via(:delete) }
            it { should_not allow_access_to(:enable, hash_with_attrs).via(:post) }
            it { should allow_access_to(:leave, hash_with_attrs).via(:post) }
          end

          context "with the role 'User'" do
            before(:each) { target.add_member!(user, "User") }
            it { should allow_access_to(:show, hash) }
            it { should_not allow_access_to(:edit, hash) }
            it { should_not allow_access_to(:update, hash_with_attrs).via(:post) }
            it { should_not allow_access_to(:destroy, hash_with_attrs).via(:delete) }
            it { should_not allow_access_to(:enable, hash_with_attrs).via(:post) }
            it { should allow_access_to(:leave, hash_with_attrs).via(:post) }
          end
        end
      end

    end

    context "for an anonymous user", :user => "anonymous" do
      it { should allow_access_to(:index) }
      it { should require_authentication_for(:new) }
      it { should require_authentication_for(:create).via(:post) }

      context "in a public space" do
        let(:target) { FactoryGirl.create(:public_space) }
        it { should allow_access_to(:show, hash) }
        it { should_not allow_access_to(:edit, hash) }
        it { should_not allow_access_to(:update, hash_with_attrs).via(:post) }
        it { should_not allow_access_to(:destroy, hash_with_attrs).via(:delete) }
        it { should_not allow_access_to(:enable, hash_with_attrs).via(:post) }
        it { should_not allow_access_to(:leave, hash_with_attrs).via(:post) }
      end

      context "in a private space" do
        let(:target) { FactoryGirl.create(:private_space) }
        it { should_not allow_access_to(:show, hash) }
        it { should_not allow_access_to(:edit, hash) }
        it { should_not allow_access_to(:update, hash_with_attrs).via(:post) }
        it { should_not allow_access_to(:destroy, hash_with_attrs).via(:delete) }
        it { should_not allow_access_to(:enable, hash_with_attrs).via(:post) }
        it { should_not allow_access_to(:leave, hash_with_attrs).via(:post) }
      end
    end

  end

  describe "#index" do
    it "sets param[:view] to 'thumbnails' if not set"
    it "sets param[:view] to 'thumbnails' if different than 'list'"
    it "uses param[:view] as 'list' if already set to this value"
    # TODO: there's a lot more to test here
  end

  it "#index.json"

  describe "#show" do
    let(:target) { FactoryGirl.create(:public_space) }
    let(:user) { FactoryGirl.create(:superuser) }
    before(:each) { sign_in(user) }

    it {
      get :show, :id => target.to_param
      should respond_with(:success)
    }

    it {
      get :show, :id => target.to_param
      should render_template("spaces/show")
    }

    it {
      get :show, :id => target.to_param
      should render_with_layout("spaces_show")
    }

    context "assigns @news_position" do
      before {
        n1 = FactoryGirl.create(:news, :space => target, :updated_at => DateTime.now - 1.day)
        n2 = FactoryGirl.create(:news, :space => target, :updated_at => DateTime.now)
      }

      context "with params[:news_position] if set" do
        before(:each) { get :show, :id => target.to_param, :news_position => "1" }
        it { should assign_to(:news_position).with(1) }
      end

      context "with 0 if params[:news_position] not set" do
        before(:each) { get :show, :id => target.to_param }
        it { should assign_to(:news_position).with(0) }
      end

      context "restricts to the amount of news existent" do
        before(:each) { get :show, :id => target.to_param, :news_position => "3" }
        it { should assign_to(:news_position).with(1) }
      end
    end

    context "assigns @news" do
      before {
        n1 = FactoryGirl.create(:news, :space => target, :updated_at => DateTime.now - 1.day)
        n2 = FactoryGirl.create(:news, :space => target, :updated_at => DateTime.now)
        n3 = FactoryGirl.create(:news, :space => target, :updated_at => DateTime.now - 2.days)
        @expected = [n2, n1, n3]
      }
      before(:each) { get :show, :id => target.to_param }
      it { should assign_to(:news).with(@expected) }
    end

    context "assigns @news_to_show" do
      before {
        n1 = FactoryGirl.create(:news, :space => target, :updated_at => DateTime.now - 1.day)
        n2 = FactoryGirl.create(:news, :space => target, :updated_at => DateTime.now)
        n3 = FactoryGirl.create(:news, :space => target, :updated_at => DateTime.now - 2.days)
        @expected = [n2, n1, n3]
      }

      context "when the target news exists" do
        before(:each) { get :show, :id => target.to_param, :news_position => "1" }
        it { should assign_to(:news_to_show).with(@expected[1]) }
      end

      context "when the target news doesn't exist" do
        before(:each) { get :show, :id => target.to_param, :news_position => "5" }
        it { should assign_to(:news_to_show).with(@expected[2]) }
      end

      context "set to nil when the space has no news" do
        before { News.destroy_all }
        before(:each) { get :show, :id => target.to_param }
        it { should assign_to(:news_to_show).with(nil) }
      end
    end

    context "assigns @latest_posts" do
      before {
        n1 = FactoryGirl.create(:post, :space => target, :updated_at => DateTime.now - 1.day)
        n2 = FactoryGirl.create(:post, :space => target, :updated_at => DateTime.now)
        n3 = FactoryGirl.create(:post, :space => target, :updated_at => DateTime.now - 2.days)
        n4 = FactoryGirl.create(:post, :space => target, :updated_at => DateTime.now - 3.days)
        @expected = [n2, n1, n3]
      }

      context "with the 3 latest posts" do
        before(:each) { get :show, :id => target.to_param }
        it { should assign_to(:latest_posts).with(@expected) }
      end

      it "ignoring posts with no parent"
      it "ignoring posts with a valid author"
      it "ignoring posts that are not related to events" # TODO: this can probably be removed
    end

    context "assigns @latest_users" do
      it "with the 3 latest members of the space"
      it "ignoring users that are nil" # TODO: review
    end

    context "assigns @upcoming_events" do
      it "with the 5 events that will happen in the future"
      it "ignoring events that already happened"
    end

    context "assigns @current_events" do
      it "with all the events that are hapenning now"
    end

    context "assigns @permission" do
      it "with the permission of the current user in the target space"
    end
  end

  describe "#show.json" do
    it "responds with the correct json"
  end

  it "#new"
  it "#edit"
  it "#create"
  it "#update"
  it "#destroy"
  it "#enable"
  it "#leave"
end

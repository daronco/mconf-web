# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

require "spec_helper"

describe BigbluebuttonRoom do

  # This is a model from BigbluebuttonRails, but we have permissions set in cancan for it,
  # so we test them here.
  describe "abilities" do
    set_custom_ability_actions([:end, :join_options, :create_meeting, :fetch_recordings,
                                :invite, :invite_userid, :auth, :running, :join, :external,
                                :external_auth, :join_mobile])

    subject { ability }
    let(:user) { nil }
    let(:ability) { Abilities.ability_for(user) }

    context "a superuser", :user => "superuser" do
      let(:user) { FactoryGirl.create(:superuser) }

      context "in his own room" do
        let(:target) { user.bigbluebutton_room }
        it { should be_able_to(:manage, target) }
      end

      context "in another user's room" do
        let(:another_user) { FactoryGirl.create(:user) }
        let(:target) { another_user.bigbluebutton_room }
        it { should be_able_to(:manage, target) }
      end

      context "in a public space" do
        let(:space) { FactoryGirl.create(:space, :public => true) }
        let(:target) { space.bigbluebutton_room }

        context "he doesn't belong to" do
          it { should be_able_to(:manage, target) }
        end

        context "he belongs to" do
          before { space.add_member!(user) }
          it { should be_able_to(:manage, target) }
        end
      end

      context "in a private space" do
        let(:space) { FactoryGirl.create(:space, :public => false) }
        let(:target) { space.bigbluebutton_room }

        context "he doesn't belong to" do
          it { should be_able_to(:manage, target) }
        end

        context "he belongs to" do
          before { space.add_member!(user) }
          it { should be_able_to(:manage, target) }
        end
      end
    end

    context "a normal user", :user => "normal" do
      let(:user) { FactoryGirl.create(:user) }

      context "in his own room" do
        let(:target) { user.bigbluebutton_room }
        let(:allowed) { [:end, :join_options, :create_meeting, :fetch_recordings,
                         :invite, :invite_userid, :auth, :running, :join, :external,
                         :external_auth, :join_mobile] }
        it { should_not be_able_to_do_anything_to(target).except(allowed) }
      end

      context "in another user's room" do
        let(:another_user) { FactoryGirl.create(:user) }
        let(:target) { another_user.bigbluebutton_room }
        let(:allowed) { [:invite, :invite_userid, :auth, :running, :join, :external,
                         :external_auth, :join_mobile] }
        it { should_not be_able_to_do_anything_to(target).except(allowed) }
      end

      context "in a public space" do
        let(:space) { FactoryGirl.create(:space, :public => true) }
        let(:target) { space.bigbluebutton_room }

        context "he doesn't belong to" do
          let(:allowed) { [:invite, :invite_userid, :auth, :running, :join, :external,
                           :external_auth, :join_mobile] }
          it { should_not be_able_to_do_anything_to(target).except(allowed) }
        end

        context "he belongs to" do
          before { space.add_member!(user) }
          let(:allowed) { [:end, :join_options, :create_meeting, :fetch_recordings,
                           :invite, :invite_userid, :auth, :running, :join, :external,
                           :external_auth, :join_mobile] }
          it { should_not be_able_to_do_anything_to(target).except(allowed) }
        end
      end

      context "in a private space" do
        let(:space) { FactoryGirl.create(:space, :public => false) }
        let(:target) { space.bigbluebutton_room }

        context "he doesn't belong to" do
          let(:allowed) { [:invite, :invite_userid, :auth, :running, :join, :external,
                           :external_auth, :join_mobile] }
          it { should_not be_able_to_do_anything_to(target).except(allowed) }
        end

        context "he belongs to" do
          before { space.add_member!(user) }
          let(:allowed) { [:end, :join_options, :create_meeting, :fetch_recordings,
                           :invite, :invite_userid, :auth, :running, :join, :external,
                           :external_auth, :join_mobile] }
          it { should_not be_able_to_do_anything_to(target).except(allowed) }
        end
      end
    end

    context "an anonymous user", :user => "anonymous" do
      context "in a user's room" do
        let(:target) { FactoryGirl.create(:user).bigbluebutton_room }
        let(:allowed) { [:invite, :invite_userid, :auth, :running] }
        it { should_not be_able_to_do_anything_to(target).except(allowed) }
      end

      context "in a public space" do
        let(:space) { FactoryGirl.create(:space, :public => true) }
        let(:target) { space.bigbluebutton_room }
        let(:allowed) { [:invite, :invite_userid, :auth, :running] }
        it { should_not be_able_to_do_anything_to(target).except(allowed) }
      end

      context "in a private space" do
        let(:space) { FactoryGirl.create(:space, :public => false) }
        let(:target) { space.bigbluebutton_room }
        let(:allowed) { [:invite, :invite_userid, :auth, :running] }
        it { should_not be_able_to_do_anything_to(target).except(allowed) }
      end
    end

  end
end

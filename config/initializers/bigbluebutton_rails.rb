Rails.application.config.to_prepare do

  # Monkey-patches to add support for guest users in bigbluebutton_rails.
  # TODO: This is not standard in BBB yet, so this should be temporary and might
  #       be moved to bigbluebutton_rails in the future.
  BigbluebuttonRoom.instance_eval do
    @guest_support = true
    class << self; attr_reader :guest_support; end
  end
  BigbluebuttonRoom.class_eval do
    # Copy of the default Bigbluebutton#join_url with support to :guest
    def join_url(username, role, password=nil, options={})
      require_server

      case role
      when :moderator
        self.server.api.join_meeting_url(self.meetingid, username, self.moderator_password, options)
      when :attendee
        self.server.api.join_meeting_url(self.meetingid, username, self.attendee_password, options)
      when :guest
        params = { :guest => true }.merge(options)
        self.server.api.join_meeting_url(self.meetingid, username, self.attendee_password, params)
      else
        self.server.api.join_meeting_url(self.meetingid, username, password, options)
      end
    end

    # Returns whether the `user` created the current meeting on this room
    # or not. Has to be called after a `fetch_meeting_info`, otherwise will always
    # return false.
    def user_created_meeting?(user)
      meeting = get_current_meeting()
      unless meeting.nil?
        meeting.created_by?(user)
      else
        false
      end
    end
  end

  BigbluebuttonServer.instance_eval do

    # The server used on Mconf-Web is always the first one. We add this method
    # to wrap it and make it easier to change in the future.
    def default
      self.first
    end

  end

  BigbluebuttonMeeting.instance_eval do
    include PublicActivity::Common
  end

end

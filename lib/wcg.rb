require 'httparty'
require 'open-uri'
require 'nokogiri'

module Wcg
  class << self
    def number_of_members
      doc = Nokogiri::HTML(open Wcg::Api::team_url(1, 10, false))
      begin
        /(\d+)/.match(doc.css('.contentTextBold+ .contentText').children.last.text)[1].to_i
      rescue
        raise WcgServiceUnavailable
      end
    end

    def get_team
      team_member_xml = Nokogiri::XML(open(Wcg::Api::team_url(1, number_of_members + 1))).css('TeamMember')
      @team ||= Wcg::Team.new(team_member_xml)
    end

    def verify_user(username, verification_code)
      username = URI.escape(username)
      verification_code = URI.escape(verification_code)
      url = "https://secure.worldcommunitygrid.org/verifyMember.do?name=#{username}&code=#{verification_code}"
      response = Wcg::Api.get(url).parsed_response
      if response['unavailable']
        raise ServiceUnavailable
      elsif response['Error']
        raise InvalidUserNameOrVerificationCode
      elsif response['MemberStatsWithTeamHistory']['MemberStats']['MemberStat']['TeamId'] != ENV['TEAM_ID']
        raise UserNotMemberOfTeam
      else
        Wcg::TeamMember.init_from_member_json(response['MemberStatsWithTeamHistory']['MemberStats']['MemberStat'])
      end
    end

    def get_team_member(username)
      # should return a Wcg::TeamMember
      response = Wcg::Api.get(Wcg::Api::member_url(username)).parsed_response
      Wcg::TeamMember.init_from_user_resource(response)
    end
  end

  class ServiceUnavailable                < Exception; end
  class InvalidUserNameOrVerificationCode < Exception; end
  class UserNotMemberOfTeam               < Exception; end
end

require 'wcg/api'
require 'wcg/team'
require 'wcg/team_member'
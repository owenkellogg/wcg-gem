module Wcg
  class Team
    attr_reader :members

    def initialize(team_members_xml)
      @members = team_members_xml.collect do |member_xml|
        Wcg::TeamMember.init_from_team_xml(member_xml)
      end
    end

    def find_member_by_id(member_id)
      members.select {|member| member.id == member_id }[0]
    end

    def total_hours
      members.inject(0) {|sum, member| sum += member.hours_contributed }
    end
  end

  class InvalidTeamXML < Exception; end
  class WcgServiceUnavailable < Exception; end
end
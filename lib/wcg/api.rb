module Wcg
  class Api
    include HTTParty
    default_timeout ENV['HTTPARTY_TIMEOUT'].to_i || 5

    class << self
      def member_url(username)
        "http://www.worldcommunitygrid.org/stat/viewMemberInfo.do?userName=#{URI.escape(username)}&xml=true"
      end

      def team_url(page, per_page, xml=true)
        url = 'https://secure.worldcommunitygrid.org/team/viewTeamMemberDetail.do'
        url << '?sort=name&teamId=0QGNJ4D832'
        url << "&pageNum=#{page}"
        url << "&numRecordsPerPage=#{per_page}"
        url << "&xml=#{xml}"
      end
    end
  end
end
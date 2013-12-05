module Wcg
  class TeamMember
    attr_reader :name, :id, :run_time, :points, :url
    def initialize(params)
      @id = params[:id].to_i
      @name = params[:name]
      @run_time = params[:run_time].to_i
      @points = params[:points].to_i
      @url = params[:url]
    end

    def self.init_from_team_xml(member_xml)
      begin
        member_id = member_xml.elements.select {|el| el.name == "MemberId" }[0]
        name = member_xml.elements.select {|el| el.name == "Name" }[0]
        member_id = member_id.children.first.text.strip
        name = name.children.first.text.strip
        stats = parse_member_stats(member_xml)
        run_time = stats[:run_time].to_i
        points = stats[:points].to_i
        url = Wcg::Api.member_url(name) rescue nil

        new(id: member_id, name: name, run_time: run_time, points: points, ur: url)
      rescue
        raise InvalidTeamMemberXML
      end
    end

    def self.init_from_user_resource(json)
      begin
        stats = json['MemberStats']['MemberStat']
        name = stats["Name"]
        member_id = stats["MemberId"]
        run_time = stats["StatisticsTotals"].try(:[], "RunTime") || 0
        points = stats["StatisticsTotals"].try(:[], "Points") || 0
        url = stats["Resource"]["Url"]
        new(id: member_id, name: name, run_time: run_time, points: points, url: url)
      rescue
        raise InvalidTeamMemberJson
      end
    end

    def self.init_from_member_json(json)
      begin
        name = json["Name"]
        member_id = json["MemberId"]
        run_time = json["StatisticsTotals"].try(:[], "RunTime") || 0
        points = json["StatisticsTotals"].try(:[], "Points") || 0
        url = json["Resource"]["Url"]
        new(id: member_id, name: name, run_time: run_time, points: points, url: url)
      rescue
        raise InvalidTeamMemberJson
      end
    end

    def hours_contributed
      @run_time / 60.0 / 60.0
    end

protected

    def self.parse_member_stats(member_xml)
      stats = member_xml.elements.select {|el| el.name == "StatisticsTotals" }[0]
      stats = stats.children.map {|child| { child.name.to_sym => child.text.strip } }
      stats.select! {|st| st.keys[0].to_s.strip != "text" }
      stats_hash = {}
      stats.map! {|st|
        key = st.keys[0]
        stats_hash[st.keys[0]] = st[key]
      }
      if stats_hash.empty?
        { run_time: 0,
          points: 0,
        }
      else
        { run_time: stats_hash[:RunTime],
          points: stats_hash[:Points]
        }
      end
    end
  end

  class InvalidTeamMemberXML  < Exception; end
  class InvalidTeamMemberJson < Exception; end
end
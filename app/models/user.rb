class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
  
  def comments(friend=uid)
    graph.get_connections(uid, 'feed', :fields => "comments", :limit => 100)
      .select{|entry| entry.has_key? "comments"}
  end
  
  def commenters(friend=uid)
    comments(friend).map {|c| c["comments"]["data"]}
      .flatten.map {|c| c["from"]}
      .group_by {|c| c["id"]}
      .map {|k,v| {"from" => v.first, "comments" => v.count}}
  end
end

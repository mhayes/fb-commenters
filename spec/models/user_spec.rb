require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
  end

  describe 'retrieving comments' do
    before do
      @stream = [
        {
          "comments"=>
          {
            "data"=>
            [
              {
                "id"=>"6411537_835012571015_2426200",
                "from"=>
                {
                  "name"=>"Mark Hayes", 
                  "id"=>"6411537"
                },
                "message"=>"What happened to the TPS report?",
                "created_time"=>"2011-03-03T04:26:07+0000"
              }
            ],
            "count"=>1
        },
          "id"=>"6411537_835012571015",
          "created_time"=>"2011-03-03T03:22:40+0000"
        }
     ]
     @graph.should_receive(:get_connections).with(@uid, 'feed', hash_including(:fields => "comments")).once.and_return(@stream)
    end
    
    describe '#comments' do
      before do
        @friend_id = 43
      end
      
      it 'should retrieve comments from the graph api' do
        @user.comments(@friend_id).should == @stream
      end
      
      it 'should group commenters by frequency' do
        commenters = [
          {
            "from"=>
            {
              "name"=>"Mark Hayes", 
              "id"=>"6411537"
            },
            "comments" => 1
          }
        ]
        
        @user.commenters(@friend_id).should == commenters
      end
    end
  end
  
  describe 'retrieving friends' do
    before do
      @friends = [
        {"name"=>"Mirko Froehlich", "id"=>"1225451"}, 
        {"name"=>"Victoria Ransom", "id"=>"1226007"}, 
        {"name"=>"Alain Chuard", "id"=>"1226772"}
      ]
      @graph.should_receive(:get_connections).with(@uid, 'friends').once.and_return(@friends)
    end
    
    it 'should retrieve my friends from the graph api' do
      @user.friends.should == @friends
    end
  end
  
  describe 'retrieving likes' do
    before do
      @likes = [
        {
          "name" => "The Office",
          "category" => "Tv show",
          "id" => "6092929747",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Flight of the Conchords",
          "category" => "Tv show",
          "id" => "7585969235",
          "created_time" => "2010-08-22T06:33:56+0000"
        },
        {
          "name" => "Wildfire Interactive, Inc.",
          "category" => "Product/service",
          "id" => "36245452776",
          "created_time" => "2010-06-03T18:35:54+0000"
        },
        {
          "name" => "Facebook Platform",
          "category" => "Product/service",
          "id" => "19292868552",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Twitter",
          "category" => "Product/service",
          "id" => "20865246992",
          "created_time" => "2010-05-02T14:07:10+0000"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'likes').once.and_return(@likes)
    end

    describe '#likes' do
      it 'should retrieve the likes via the graph api' do
        @user.likes.should == @likes
      end

      it 'should memoize the result after the first call' do
        likes1 = @user.likes
        likes2 = @user.likes
        likes2.should equal(likes1)
      end
    end

    describe '#likes_by_category' do
      it 'should group by category and sort categories and names' do
        @user.likes_by_category.should == [
          ["Product/service", [
            {
              "name" => "Facebook Platform",
              "category" => "Product/service",
              "id" => "19292868552",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Twitter",
              "category" => "Product/service",
              "id" => "20865246992",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Wildfire Interactive, Inc.",
              "category" => "Product/service",
              "id" => "36245452776",
              "created_time" => "2010-06-03T18:35:54+0000"
            }
          ]],
          ["Tv show", [
            {
              "name" => "Flight of the Conchords",
              "category" => "Tv show",
              "id" => "7585969235",
              "created_time" => "2010-08-22T06:33:56+0000"
            },
            {
              "name" => "The Office",
              "category" => "Tv show",
              "id" => "6092929747",
              "created_time" => "2010-05-02T14:07:10+0000"
            }
          ]]
        ]
      end
    end
  end
end

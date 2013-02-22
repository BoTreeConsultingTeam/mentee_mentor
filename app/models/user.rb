class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  # To allow mass assignment for association having accepts_nested_attributes_for
  # enabled.
  attr_accessible :profile_attributes

  has_many :message_threads, foreign_key: 'starter_id'
  has_many :messages_received, class_name: 'Message', foreign_key: 'receiver_id'
  has_many :messages_sent, class_name: 'Message', foreign_key: 'sender_id'

  has_many :followings, class_name: 'FollowedFollowing', foreign_key: 'followed_id', dependent: :destroy
  # :source is used to specify the column of the related entity
  # (FollowedFollowing, in present case) against which JOIN will be made in the
  # query with source entity(User, in present case ).
  # For e.g. this would generate following query :
  # SELECT `users`.* FROM `users` INNER JOIN `followed_followings` ON `users`.`id` = `followed_followings`.`following_id`
  # WHERE `followed_followings`.`followed_id` = 4
  # (check the ON clause which is generated by taking into account the :source option value)
  has_many :followed_by, through: :followings, source: :following

  has_many :follows_users, class_name: 'FollowedFollowing', foreign_key: 'following_id', dependent: :destroy
  has_many :follows, through: :follows_users, source: :followed

  has_many :authentications, dependent: :delete_all

  has_many :user_resources
  has_many :resources, :through => :user_resources

  # References for overriden eqll? and hash:
  # 1) http://shortrecipes.blogspot.in/2006/10/ruby-intersection-of-two-arrays-of.html
  # 2) http://www.ruby-forum.com/topic/181819
  def eql?(other)
    (other.kind_of?(self.class) && !self.id.nil? && self.id == other.id)
  end

  def hash
    self.id
  end

  def other_users
    User.where("id != ?", self.id)
  end

  def connected_with
    (self.followed_by & self.follows)
  end

  def is_followed_by
    (self.followed_by - self.connected_with)
  end

  def is_following
    (self.follows - self.connected_with)
  end

  def can_follow
    ((other_users - self.connected_with) - self.is_following)
  end

  def message_threads_exchanged_with(user_id)
    return [] if user_id.nil?

    messages_from_user = messages_received.where(sender_id: user_id)
    messages_to_user = messages_sent.where(receiver_id: user_id)
    message_thread_ids = (messages_from_user + messages_to_user).collect do |message|
                            message.message_thread.id
                         end
    MessageThread.where(id: message_thread_ids).to_a
  end

  def name
    return self.email if profile.nil?

    first_name = profile.first_name
    last_name = profile.last_name

    if (first_name.present? and last_name.present?)
      [first_name, last_name].join(" ")
    elsif first_name.present?
      first_name
    else
      self.email
    end
  end

  def apply_omniauth(omniauth)
    user_info_hash = omniauth[:user_info]

    unless user_info_hash.empty?
      self.email = user_info_hash[:email]

      #self.first_name = user_info_hash[:first_name]
      #self.last_name = user_info_hash[:last_name]

      case omniauth[:provider]
        when 'facebook'
          #self.facebook = user_info_hash[:url]
          #self.photo = URI.parse(user_info_hash[:image]) if user_info_hash[:image]
      end
    end
  end

  def connected_to_linkedin?
    !authentications.find_by_provider("linkedin").nil?
  end

end

class Item < ActiveRecord::Base
  belongs_to :user
  has_many :votes, as: :votable
  has_many :comments, class_name: "ItemComment"

  validates :title, presence: true, length: { maximum: 250 }, allow_blank: false, allow_nil: false, uniqueness: true
  validates :id, uniqueness: true

  after_create :slack_post
  # validate do
  #   if content.blank? && url.blank?
  #     errors.add(:url, 'Submit a URL or Content')
  #   end
  #   if content.present? && url.present?
  #     errors.add(:url, 'Submit a URL or Content but not Both.')
  #   end
  # end
  # validates :url, url: {allow_nil: true, allow_blank: true}


  scope :active, -> { where(disabled: false) }
  scope :disabled, -> { where(disabled: true) }
  scope :newest, -> { order(score: :desc) }


  def slack_post
    notifier = Slack::Notifier.new ENV["slack_link"]
    post = "NEW BOOK ADDED : " + self.title + ", by @" +self.user.username + ", [Visit the Library](http://mangrove-library.herokuapp.com/items/newest)"
    notifier.ping post
  end
end

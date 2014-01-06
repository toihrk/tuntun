class Poke
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :time, type: Integer, default: 5
  field :message, type: String, default: ""
  field :open, type: Boolean, default: false

  has_mongoid_attached_file :image, styles: {thumb: "100x100>" }

  belongs_to :author, class_name: "User", inverse_of: :poked
  belongs_to :target, class_name: "User", inverse_of: :targeted
end

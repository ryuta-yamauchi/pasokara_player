# _*_ coding: utf-8 _*_
class Directory < ActiveRecord::Base
  include OnlineFind
  external_encoding "UTF-8" if self.respond_to?(:external_encoding)
  has_many :directories, :order => 'name'
  has_many :pasokara_files, :order => 'name'
  belongs_to :directory
  belongs_to :computer

  validates_uniqueness_of :fullpath, :scope => [:computer_id]

  def entities
    (directories + pasokara_files)
  end

  def fullpath
    if WIN32
      self["fullpath"].tosjis.gsub(/\//, "\\")
    else
      self["fullpath"]
    end
  end

end

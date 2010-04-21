# _*_ coding: utf-8 _*_

class QueuedFile < ActiveRecord::Base
  belongs_to :pasokara_file


  def self.enq(pasokara, user_id = nil)
    QueuedFile.create do |q|
      q.pasokara_file = pasokara
    end

    PasokaraNotifier.instance.queue_notify(pasokara.name)
  end

  def self.deq
    queue = QueuedFile.find(:first, :order => "created_at")
    if queue
      SingLog.create(:pasokara_file_id => queue.pasokara_file_id)
      queue.destroy
    end
    queue
  end

end

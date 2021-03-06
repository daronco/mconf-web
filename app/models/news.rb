# Copyright 2008-2010 Universidad Politécnica de Madrid and Agora Systems S.A.
#
# This file is part of VCC (Virtual Conference Center).
#
# VCC is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# VCC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with VCC.  If not, see <http://www.gnu.org/licenses/>.

class News < ActiveRecord::Base
  belongs_to :space

  validates_presence_of :title, :text, :space_id

  acts_as_resource
  acts_as_content :reflection => :space

  class << self
    def params_from_atom(entry)
      { :title => entry.title.to_s,
        :text => ( entry.content.to_s.present? ? entry.content.to_s : entry.title.to_s ) }
    end
  end
end

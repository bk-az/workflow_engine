module MembersHelper
  def member_full_name(member_obj)
    "#{member_obj.first_name} #{member_obj.last_name}"
  end
end

class UserSearch < Search

    def by_all_secretary
      ["role = ?", 2]
    end
end
module LockManager
  def grab_ex_lock
    @file.flock(File::LOCK_EX)
  end

  def grab_sh_lock
    @file.flock(File::LOCK_SH)
  end

  def release_lock
    @file.flock(File::LOCK_UN)
  end
end

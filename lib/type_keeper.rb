module TypeKeeper
	VALID_NAME_TPYES = ['String']
	VALID_VALUE_TPYES = ['Integer', 'Fload', 'Boolean', 'Array', 'NilClass']
	def keeping(hash)
		return if KVJ_CONFIG['auto_key_casting'] = true
		invalid_keys = hash.flatten.keys.collect { |key| !VALID_NAME_TPYES.include?(key.class.to_s) }
#		raise 'following key hasn'
#		invalid_values = values.collect { |value| !VALID_VALUE_TPYES.include?(value.class) }
#		array_values = values.collect { |value| }
	end
end

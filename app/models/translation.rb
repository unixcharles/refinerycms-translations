class Translation < ActiveRecord::Base

  acts_as_indexed :fields => [:name]

  validates_presence_of :name

  before_update { |record| Translation.cache_expire(record.name, record.locale, record.untranslated_was) }
  after_save    { |record| Translation.cache_write(record.name, record.locale, record.untranslated, record.value) }

  class << self
    # will_paginate per_page
    def per_page
      20
    end

    # Caching methods
    def cache_key(name, locale, untranslated)
      "#{Refinery.base_cache_key}_translation_#{name}_#{locale.to_s}_#{Digest::MD5.hexdigest(untranslated)}"
    end

    def cache_read(name, locale, untranslated)
      Rails.cache.read(cache_key(name, locale, untranslated))
    end

    def cache_expire(name, locale, untranslated)
      Rails.cache.delete(cache_key(name, locale, untranslated))
    end

    def cache_write(name, locale, untranslated, value)
      Rails.cache.write(cache_key(name, locale, untranslated), value)
    end

    def for_block(name, wym = true)
      self.lookup(name, yield, wym)
    end

    def for_string(name, untranslated, wym = false)
      self.lookup(name, untranslated, wym)
    end

    def lookup(name, untranslated = nil, wym = false)
      locale = I18n.locale
      return untranslated if locale == Refinery::I18n.default_locale

      if translation = self.cache_read(name,locale,untranslated)
        return translation
      end if use_cache?

      if ( translation = self.find(:first, :conditions => {:name => name.to_s, :locale => locale.to_s}) ).nil?
        (Refinery::I18n.locales.keys - [Refinery::I18n.default_frontend_locale]).each do |current_locale|
          if (translation = self.find(:first, :conditions => {:name => name, :locale => current_locale.to_s})).nil?
            Translation.create(:name => name, :locale => current_locale.to_s, 
                               :value => untranslated, :untranslated => untranslated,:wym => wym,
                               :fresh => false, :freshness_key => Digest::MD5.hexdigest(untranslated))
          end
        end
        translation = self.find(:first, :conditions => {:name => name.to_s, :locale => locale.to_s})
      else
        if translation.fresh
          unless translation.freshness_key == Digest::MD5.hexdigest(untranslated)
            translation.freshness_key = Digest::MD5.hexdigest(untranslated)
            translation.untranslated = untranslated
            translation.fresh = false
            translation.save
          end
        end
      end

      self.cache_write(name, locale, untranslated, translation.value) if use_cache?
      translation.value
    end

    def use_cache?
      @use_cache ||= RefinerySetting.find_or_set(:i18n_frontend_cache_translation, true, {:scoping => 'refinery'})
    end

  end
end

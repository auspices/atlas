# frozen_string_literal: true

module StringHelper
  OMISSION = '…'

  def truncate(string, length: nil, from: :tail, skip_url: false)
    return string unless length
    return string if string.length == 1

    return truncate_url(string, length: length, from: from) if string.start_with?('http') && !skip_url

    truncate_string(string, length: length, from: from)
  end

  def truncate_string(string, length: nil, from: :tail)
    return string unless length

    case from
    when :head
      string.reverse.truncate(length, omission: OMISSION).reverse
    when :center
      chars = string.chars
      head, tail = chars.each_slice((chars.size / 2.0).round).to_a
      head.join('').truncate(length / 2, omission: OMISSION) + tail.last(length / 2).join('')
    when :tail
      string.truncate(length, omission: OMISSION)
    else
      raise "unsupported `from: :#{from}`"
    end
  end

  def truncate_url(string, length: nil, from: :tail)
    return string unless length

    normalized = normalize_url(string)

    return normalized if normalized.length <= length

    sans_www = normalized.gsub(/^www\./, '')
    return sans_www if sans_www.length <= length

    truncate(sans_www, length: length, from: from, skip_url: true)
  end

  def normalize_url(string)
    uri = Addressable::URI.heuristic_parse(CGI.unescape(string))
    [uri.host, uri.path].reject(&:blank?).join('').gsub(%r{\/+$}, '')
  rescue StandardError
    string
  end
end

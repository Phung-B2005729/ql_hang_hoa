

exports.escapeStringRegexp = (string) => {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}


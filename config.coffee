yaml = require 'js-yaml'
fs   = require 'fs'
config = fs.readFileSync './config.yaml' , 'utf8'
module.exports = yaml.load config
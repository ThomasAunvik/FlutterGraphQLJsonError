final documentNodeUser = """
query User(\$id: String){
  user(id: \$id) {
    id
    name
    stats {
      data
    }
  }
}
""";

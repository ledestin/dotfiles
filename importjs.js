module.exports = {
  importStatementFormatter({ importStatement }) {
    // replaceAll() causes this function to fail.
    return importStatement.replace(/;$/, '')
      .replace("'", '"').replace("'", '"');
  }
}

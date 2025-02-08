function handler(event) {
  const request = event.request;
  const headers = request.headers;

  // echo -n "user:pass" | base64
  const authString = "Basic ${auth_string}";

  if (
    typeof headers.authorization === "undefined" ||
    headers.authorization.value !== authString
  ) {
    return {
      statusCode: 401,
      statusDescription: "Unauthorized",
      headers: { "www-authenticate": { value: "Basic" } }
    };
  }

  return request;
}

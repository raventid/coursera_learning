use super::rocket;
use rocket::testing::MockRequest;
use rocket::http::{Method, Status};
// Link length limit
// Link is broken, check or not?
// Link with xss inside, filter it or not
// Get link if it exists
// Get empty result if it does not exists
// Key already exists in storage(use setnx with exception handling) and spec for this case
// Benchmarks
// Docs(with runnable docs)
//
//
//
// fn test_200(uri: &str, expected_body: &str) {
//     let rocket = rocket::ignite().mount("/", routes![super::root, super::user, super::login]);
//     let mut request = MockRequest::new(Method::Get, uri);
//     let mut response = request.dispatch_with(&rocket);
//
//     assert_eq!(response.status(), Status::Ok);
//     assert_eq!(response.body_string(), Some(expected_body.to_string()));
// }
//
// fn test_303(uri: &str, expected_location: &str) {
//     let rocket = rocket::ignite().mount("/", routes![super::root, super::user, super::login]);
//     let mut request = MockRequest::new(Method::Get, uri);
//     let response = request.dispatch_with(&rocket);
//     let location_headers: Vec<_> = response.headers().get("Location").collect();
//
//     assert_eq!(response.status(), Status::SeeOther);
//     assert_eq!(location_headers, vec![expected_location]);
// }

#[test]
fn test() {
    let rocket = rocket::ignite().mount("/", routes![super::shorten, super::lookup]);
    let mut request = MockRequest::new(Method::Get, "/my_super_url");
    let response = request.dispatch_with(&rocket);
    assert_eq!(response.status(), Status::Ok);
    //assert_eq!(response.body_string(),
    //           Some("You shortened my_super_url. Magnificient!".into()));
}

#[test]
fn test_redirect_to_full_url() {
    let rocket = rocket::ignite().mount("/", routes![super::shorten, super::lookup]);
    let mut request = MockRequest::new(Method::Get, "/ghtyu");
    let mut response = request.dispatch_with(&rocket);
    let body_string = response.body().and_then(|b| b.into_string());
    assert_eq!(response.status(), Status::Ok);
    assert_eq!(body_string,
               Some("You shortened ghtyu. Magnificient!".to_string()));
}

#[test]
fn test_json_response() {
    let rocket = rocket::ignite().mount("/", routes![super::shorten, super::lookup, super::create]);
    let mut request = MockRequest::new(Method::Post, "/")
        .header(rocket::http::ContentType::JSON)
        .body(r#"{ "url": "https://kupibilet.ru/i_hate_this_long_url"}"#);
    let mut response = request.dispatch_with(&rocket);
    let body_string = response.body().unwrap().into_string().unwrap();
    let expected = r#"{"url":"https://kupibilet.ru/gh45"}"#;
    assert_eq!(response.status(), Status::Ok);
    assert_eq!(body_string, expected);
}

// #[test]
// fn test_redirects() {
//     test_303("/", "/users/login");
//     test_303("/users/unknown", "/users/login");
// }

import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Root of our server
    router.get { req -> Future<View> in
        // All page data that will be sent put in a neat struct
        struct PageData: Content {
            var cupcakes: [Cupcake]
            var orders: [Order]
        }
        
        // Get both all the cakes and all the orders from the database
        let cakes = Cupcake.query(on: req).all()
        let orders = Order.query(on: req).all()
        
        // Returns cakes and orders as data to leaf template
        return flatMap(to: View.self, cakes, orders, { cakes, orders in
            let content = PageData(cupcakes: cakes, orders: orders)
            return try req.view().render("home", content)
        })
    }
    
    // (Content type expetation, url)
    router.post(Cupcake.self, at: "add") { req, cupcake -> Future<Response> in
        return cupcake.save(on: req).map(to: Response.self) { cupcake in
            return req.redirect(to: "/")
        }
    }
    
    // Page for cupcakes page, shows data
    router.get("cupcakes") { req -> Future<[Cupcake]> in
        return Cupcake.query(on: req).sort(\.name).all()
    }
    
    // (Content type expetation, url)
    router.post(Order.self, at: "order") { req, order -> Future<Order> in
        var orderCopy = order
        orderCopy.date = Date() // Current Date
        return orderCopy.save(on: req)
    }
}

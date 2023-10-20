import SwiftUI
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SkeletonModifier: ViewModifier {
    let shape: ShapeType
    let animation: AnimationType
    let appearance: AppearanceType
    @State var animate: Bool = false

    public func body(content: Content) -> some View {
        content
            .modifier(SkeletonAnimatableModifier(CGFloat(integerLiteral: Int(truncating: animate as NSNumber)), appearance))
            .animation(animation.type,value: animate)
            .clipShape(SkeletonShape(shape))
            .onAppear { animate.toggle() }
    }
}
struct User: Identifiable {
    let id = UUID()
    let name: String
}
struct UsersView: View {
    @State var users = [User]()

    var body: some View {
        SkeletonList(with: users, quantity: 6) { loading, user in
            Text(user?.name)
                .skeleton(with: loading)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.users = [User(name: "John Doe"),
                              User(name: "Jane Doe"),
                              User(name: "James Doe"),
                              User(name: "Judy Doe")]
            }
        }
    }
}
#Preview{
    UsersView()
}

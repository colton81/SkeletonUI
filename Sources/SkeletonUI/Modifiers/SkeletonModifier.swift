import Combine
import SwiftUI

// MARK: - SkeletonModifier

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SkeletonModifier: ViewModifier {
    let shape: ShapeType
    let animation: AnimationType
    let appearance: AppearanceType
    @State var animate: Bool = false

    public func body(content: Content) -> some View {
        content
            .modifier(SkeletonAnimatableModifier(CGFloat(integerLiteral: Int(truncating: animate as NSNumber)), appearance))
            .animation(animation.type, value: animate)
            .clipShape(SkeletonShape(shape))
            .onAppear { animate.toggle() }
    }
}

// MARK: - User

struct User: Identifiable {
    let id = UUID()
    let name: String
}
enum LoadingState{
    case loading
    case finished
}
// MARK: - UsersView

struct UsersView: View {
    @State var users = [User(name: "John Doe")]
    @State var loadingState:LoadingState = .loading
    var body: some View {
        List(users){ user in
            PopListCard(
                loadingState: .loading,
                name: nil,
                //city: "Spring",
                //state: "TX",
                phone: "346-242-2610",
                email: "coltonhillebrand92@gmail.com"
            )
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
struct PopListCard: View {
    // MARK: - Properties
    var loadingState:LoadingState
    /// The name to display on the card
    var name: String?
    var department: String?
    /// The city and state to display on the card
    var city: String?
    var state: String?
    
    /// The phone number to display on the card
    @State var phone: String?
    @State private var isPhoneValidated = false
    /// The email address to display on the card
    @State var email: String?
    /// Default URL for phone and email links
    let defaultPhone = URL(string: "tel:000-000-0000")!
    let defaultEmail = URL(string: "mailto:noemail@url.com")!
    var hasIcons = true
    // MARK: - Body
    var body: some View {
        LabeledContent(content: {
            Link(destination: URL(string: "tel://\(String(describing: phone))") ?? self.defaultPhone) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 32.0, weight: .regular))
                    .foregroundColor(isPhoneValidated ? Color.green : Color.gray.opacity(0.8))
                    .padding([.trailing, .leading], 5)
            } // Link
            .buttonStyle(.plain) // Use a plain button style to allow clicking within a list view
            .disabled(!isPhoneValidated)
            Link(destination: URL(string: "mailto:\(email ?? "")") ?? defaultEmail) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 32.0, weight: .regular))
                    .foregroundColor(email != nil ? Color.accentColor : Color.gray.opacity(0.8))
                    .padding([.trailing, .leading], 0)
            } // Link
            .buttonStyle(.plain) // Use a plain button style to allow clicking within a list view
            
        }, label: {
            Group {
                Text(name ?? "")
                    .lineLimit(3)
                    .font(.system(size: 17, weight: .regular))
                    .padding(.leading, 5)
                    .multilineTextAlignment(.leading)
                    .skeleton(
                        with: loadingState == .loading,
                        shape:.rounded(.radius(5, style: .continuous))
                    )
                
                    .frame(maxWidth:loadingState == .loading ? 175:.infinity,alignment:.leading)
                
                HStack(spacing: loadingState == .loading ? 10:0) {
                    Text(city ?? "")
                        .padding(.leading, 5)
                        .multilineTextAlignment(.leading)
                        .skeleton(with: loadingState == .loading,shape:.rounded(.radius(5, style: .continuous)),lines: 1)
                        .frame(width:loadingState == .loading ? 100:.infinity,alignment:.leading)
                    //.frame(maxWidth:100,maxHeight:15)
                    if state != nil {
                        Text(",")
                    }
                    
                    Text(state ?? "")
                        .padding(.leading, 5)
                        .multilineTextAlignment(.leading)
                        .skeleton(with: loadingState == .loading,shape:.rounded(.radius(5, style: .continuous)),lines: 1)
                        .frame(width:loadingState == .loading ? 50:.infinity,alignment:.leading)
                }
                .lineLimit(1)
                .font(.system(size: 16))
                .foregroundColor(Color.gray.opacity(0.9))
                
                
            }
            
        })
        .padding(.vertical,loadingState == .loading ? 10:0)
        .onAppear {
            self.phone = self.formatPhoneNumberForURL(phone ?? "")
            self.isPhoneValidated = self.validate(value: phone ?? "")
        }
        .frame(minHeight: 50)
        .cornerRadius(2) // Set the corner radius of the card
    }
    
    func validate(value: String) -> Bool {
        let PHONEREGEX = "^\\+?[1-9]\\d{9,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONEREGEX)
        return phoneTest.evaluate(with: value)
    }
    
    private func removeFormatting(_ phoneNumber: String) -> String {
        let unwantedCharacters: [Character] = ["(", ")", " ", "-"]
        let cleanPhoneNumber = phoneNumber.filter { !unwantedCharacters.contains($0) }
        return cleanPhoneNumber
    }
    
    // MARK: - Private functions
    private func formatPhoneNumberForURL(_ phoneNumber: String) -> String {
        let cleanPhoneNumber = removeFormatting(phoneNumber)
        return cleanPhoneNumber
    }
}
#Preview {
    UsersView()
}

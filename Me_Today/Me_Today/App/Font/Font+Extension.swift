import SwiftUI

enum PretendardFont: String {
    case bold = "Pretendard-Bold"
    case medium = "Pretendard-Medium"
    case semibold = "Pretendard-Semibold"
}
enum WantedSansFont: String {
    case bold = "WantedSans-Bold"
    case semibold = "WantedSans-SemiBold"
    case regular = "WantedSans-Regular"
}
enum GangwonFont: String {
    case extrabold = "Power"
}
enum PyeongChangFont: String {
    case bold = "PyeongChang-Bold"
}

extension Font {
    static func pretendard(_ style: PretendardFont, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
    static func wantedSans(_ style: WantedSansFont, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
    static func gangwon(_ style: GangwonFont, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
    static func pyeongChang(_ style: PyeongChangFont, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
}

extension UIFont {
    static func pretendard(_ style: PretendardFont, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
    static func wantedSans(_ style: WantedSansFont, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
    static func gangwon(_ style: GangwonFont, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
    static func pyeongChang(_ style: PyeongChangFont, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
}

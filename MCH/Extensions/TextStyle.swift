//
//  TextStyle.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Foundation
import UIKit

public struct TextStyle: Equatable {

    public let font: UIFont
    public let textColor: UIColor
    public let paragraphSpacing: CGFloat?
    public let paragraphIndent: CGFloat?
    public let lineHeight: CGFloat?
    public let letterSpacing: CGFloat?

    public var actualLineHeight: CGFloat {
        return lineHeight ?? font.lineHeight
    }

    public init(
        font: UIFont,
        textColor: UIColor,
        paragraphSpacing: CGFloat? = nil,
        paragraphIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat? = nil
    ) {
        self.font = font
        self.textColor = textColor
        self.paragraphSpacing = paragraphSpacing
        self.paragraphIndent = paragraphIndent
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }

    public init(
        fontName: String,
        fontSize: CGFloat,
        textColor: UIColor,
        paragraphSpacing: CGFloat? = nil,
        paragraphIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat? = nil
    ) {
        self.init(
            font: UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            textColor: textColor,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing
        )
    }

    public func withTextColor(_ textColor: UIColor) -> TextStyle {
        return TextStyle(
            font: font,
            textColor: textColor,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing
        )
    }

    public func attributes(
        textColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        ignoringParagraphStyle: Bool = false
    ) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor ?? self.textColor,
        ]

        if let backgroundColor = backgroundColor {
            attributes[.backgroundColor] = backgroundColor
        }

        if let letterSpacing = letterSpacing {
            attributes[.kern] = NSNumber(value: Float(letterSpacing))
        }

        if ignoringParagraphStyle {
            return attributes
        }

        let paragraphStyle = NSMutableParagraphStyle()

        if let lineHeight = lineHeight {
            let paragraphLineSpacing = (lineHeight - font.lineHeight) / 2.0
            let paragraphLineHeight = lineHeight - paragraphLineSpacing

            paragraphStyle.lineSpacing = paragraphLineSpacing
            paragraphStyle.minimumLineHeight = paragraphLineHeight
            paragraphStyle.maximumLineHeight = paragraphLineHeight
        }

        if let paragraphSpacing = paragraphSpacing {
            paragraphStyle.paragraphSpacing = paragraphSpacing
        }

        if let paragraphIndent = paragraphIndent {
            paragraphStyle.firstLineHeadIndent = paragraphIndent
        }

        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }

        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        } else {
            paragraphStyle.lineBreakMode = .byTruncatingTail
        }

        attributes[.paragraphStyle] = paragraphStyle

        return attributes
    }
}

public extension TextStyle {

    static let title2 = TextStyle(
        fontName: "SFProDisplay-Bold",
        fontSize: 24.0,
        textColor: UIColor.Brand.black,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 28.0,
        letterSpacing: 0.0
    )

    static let title1 = TextStyle(
        fontName: "SFProDisplay-Bold",
        fontSize: 20.0,
        textColor: UIColor.Brand.black,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 24.0,
        letterSpacing: 0.2
    )

    static let label = TextStyle(
        fontName: "SFProText-Regular",
        fontSize: 16.0,
        textColor: UIColor.Brand.black,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 20.0,
        letterSpacing: -0.3
    )

    static let body = TextStyle(
        fontName: "SFProText-Regular",
        fontSize: 14.0,
        textColor: UIColor.Brand.black,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 18.0,
        letterSpacing: -0.2
    )
}

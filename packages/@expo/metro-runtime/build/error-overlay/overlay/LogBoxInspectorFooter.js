/**
 * Copyright (c) 650 Industries.
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
import React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useSelectedLog } from '../Data/LogContext';
import * as LogBoxStyle from '../UI/LogBoxStyle';
export function LogBoxInspectorFooter(props) {
    const log = useSelectedLog();
    if (['static', 'syntax'].includes(log.level)) {
        return (React.createElement(View, { style: styles.root },
            React.createElement(View, { style: styles.button },
                React.createElement(Text, { style: styles.syntaxErrorText }, "This error cannot be dismissed."))));
    }
    return (React.createElement(View, { style: styles.root },
        React.createElement(FooterButton, { text: "Dismiss", onPress: props.onDismiss }),
        React.createElement(FooterButton, { text: "Minimize", onPress: props.onMinimize })));
}
function FooterButton({ text, onPress }) {
    return (React.createElement(Pressable, { onPress: onPress, style: { flex: 1 } }, ({ 
    /** @ts-expect-error: react-native types are broken. */
    hovered, pressed, }) => (React.createElement(View, { style: [
            buttonStyles.safeArea,
            {
                // @ts-expect-error: web-only type
                transitionDuration: '150ms',
                backgroundColor: pressed
                    ? '#323232'
                    : hovered
                        ? '#111111'
                        : LogBoxStyle.getBackgroundColor(),
            },
        ] },
        React.createElement(View, { style: buttonStyles.content },
            React.createElement(Text, { style: buttonStyles.label }, text))))));
}
const buttonStyles = StyleSheet.create({
    safeArea: {
        flex: 1,
        borderTopWidth: 1,
        borderColor: '#323232',
        // paddingBottom: DeviceInfo.getConstants().isIPhoneX_deprecated ? 30 : 0,
    },
    content: {
        alignItems: 'center',
        height: 48,
        justifyContent: 'center',
    },
    label: {
        userSelect: 'none',
        color: LogBoxStyle.getTextColor(1),
        fontSize: 14,
        includeFontPadding: false,
        lineHeight: 20,
    },
});
const styles = StyleSheet.create({
    root: {
        backgroundColor: LogBoxStyle.getBackgroundColor(1),
        boxShadow: `0 -2px 0 2px #000`,
        flexDirection: 'row',
    },
    button: {
        flex: 1,
    },
    syntaxErrorText: {
        textAlign: 'center',
        width: '100%',
        height: 48,
        fontSize: 14,
        lineHeight: 20,
        paddingTop: 20,
        paddingBottom: 50,
        fontStyle: 'italic',
        color: LogBoxStyle.getTextColor(0.6),
    },
});
//# sourceMappingURL=LogBoxInspectorFooter.js.map
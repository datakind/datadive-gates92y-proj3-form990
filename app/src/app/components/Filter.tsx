import * as React from 'react';
import * as _ from 'lodash';

export interface FilterOption {
    key: string | number;
    value: string;
}

interface FilterProps {
    label: string;
    options: FilterOption[];
    showAny?: boolean;
    handleOptionChange: (value: string | number) => void;
}

export class Filter extends React.Component<FilterProps, undefined> {

    constructor(props: FilterProps) {
        super(props);

        this._handleChange = this._handleChange.bind(this);
    }

    render() {
        return (<div className="filter">
            <label>{this.props.label}</label>
            <select onChange={this._handleChange}>
                {!!this.props.showAny && <option value="">Any</option>}
                {this.props.options.map(f => {
                    return <option key={f.key} value={f.key}>{f.value}</option>;
                })}
            </select>
        </div>);
    }

    _handleChange(event: any) {
        this.props.handleOptionChange(event.target.value);
    }
}

import * as React from 'react';

interface FilterProps {
    label: string;
    options: string[];
    handleOptionChange: (value: string) => void;
}

interface FilterState {
    value: string;
}

export class Filter extends React.Component<FilterProps, FilterState> {

    constructor(props: FilterProps) {
        super(props);

        this.state = {
            value: ''
        };

        this._handleChange = this._handleChange.bind(this);
    }

    render() {
        return (<div className="filter">
            <label>{this.props.label}</label>
            <select onChange={this._handleChange}>
                {this.props.options.map(o => {
                    return <option key={o} value={o}>{o}</option>;
                })}
            </select>
        </div>);
    }

    _handleChange(event: any) {
        this.props.handleOptionChange(event.target.value);
        // this.setState({ value: event.target.value }, () => {

        // });
    }
}
